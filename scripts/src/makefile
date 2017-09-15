include Make.inc
###############################

TARGETS= generate analysiser

all: ${TARGETS}

generate: generate.cpp
	${CXX} generate.cpp -o ${SCRIPTdir}/generate ${CXXFLAGS}

analysiser: analysiser.cpp
	${CXX} analysiser.cpp -o ${HPLdir}/analysiser ${CXXFLAGS}

.PHONY: clean

clean: 
	rm -f ${SCRIPTdir}/generate
	rm -f ${HPLdir}/analysiser
