#!/bin/sh
#

nmcli c up labsec &> /dev/null
flatpak run app.devsuite.Ptyxis --tab-with-profile=88f46ca26bf834bcabe8c6db6642ba52
