#!/bin/bash

cd console
java -cp ".:./*:../libs/*" org.nem.console.Main $*
cd -