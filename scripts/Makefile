# Make.inc
# defines HPLdir where xhpl locates
include Make.inc

##################################

all: leaf cp_files build_up

leaf:
	ln -f Make.inc ${SRCdir}/Make.inc

cp_files:
	mkdir -p ${SCRIPTdir}
	cp -f ${DATdir}/* ${SCRIPTdir}
	cp -f ${SRCdir}/run.sh ${HPLdir}
#	cp -f ${SRCdir}/gen.sh ${SCRIPTdir}
	mkdir -p ${SCRIPTdir}/Data

build_up:
	cd ${SRCdir} && make

.PHONY: clean

clean:
	cd ${SRCdir} && make clean
	-rm -rf ${SCRIPTdir}
	-rm -f ${HPLdir}/run.sh
