class_name StringLogger
extends Node

var logged := ""

func write_line(newstr:String):
	logged += newstr + "\n"

func write(newstr:String):
	logged += newstr