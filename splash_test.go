package main

import (
	"dlib"
	"testing"
	// "time"
)

func TestSplash(t *testing.T) {
	initBackground()
	initBackgroundAfterCompizLoaded()
	go dlib.StartLoop()
	// time.Sleep(10 * time.Second)
	select {}
}
