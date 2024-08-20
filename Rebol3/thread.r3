#!/usr/local/bin/r3
Red [
]

random/seed now/time/precise

scheduler: make object! [
	threadCount: 0		;--number of threads
	threadList: []		;--list of threads
	
	appendThread: func [
		athread	[object!]
	][
		append threadList athread 		;--append a thread to threadList
		threadCount: threadCount + 1	;--inc the number of active threads	
	]
		
	startMessageLoop: func [] [
		i: 1
		while [i <= threadCount] [
			cthread: threadList/:i									;--get current thread
			cthread/tTrigger: cthread/tCount % cthread/tPriority	;--0 to code pointer be executed
			cthread/tExecute										;--code pointer execute
			cthread/tCount: cthread/tCount + 1						;--next thread
			i: i + 1
		]
	]
]

rThread: make object! [
	tNumber: 		0 ;--thread number
	tPriority: 		1 ;--thread priority  [1 to N (high to low)]
	tCount: 		0 ;--thread calls counter
	tTrigger: 		0 ;--trigger for code pointer execution	
	tExecute:    none ;--func as code pointer 
]

initThreads: does [
	;--create threads 1 and 2 (make required)
	t1: make rThread [tNumber: 1 tPriority: 1  tExecute: :showString]
	t2: make rThread [tNumber: 2 tPriority: 30 tExecute: :showTime]
	;--register threads in scheduler
	scheduler/AppendThread t1
	scheduler/AppendThread t2
]

;--code pointers
showString: does [if t1/tTrigger = 0 [print ["Hello R3 World" random 1.0]]]
showTime:   does [if t2/tTrigger = 0 [print ["At:" now/time/precise]]]

;--create threads
initThreads 

;--execute scheduler loop
repeat i 1000 [scheduler/StartMessageLoop]

