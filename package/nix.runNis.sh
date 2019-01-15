#!/bin/bash

cd nis
java -Xms512M -Xmx1G -cp ".:./*:../libs/*" org.nem.deploy.CommonStarter
cd -
