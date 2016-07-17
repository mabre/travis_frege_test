BUILD       = build
BUILD_DIRS  = $(BUILD)
DIST        = dist

FREGEJAR = frege.jar
ALEX     = alex
CLIJAR   = Libraries/commons-cli-1.3.1.jar
JAVAC    = javac -cp $(FREGEJAR):${BUILD}:$(CLIJAR)
JAVA     = java
MKDIR_P  = mkdir -p
RM       = rm -rf
MV       = mv
BASH     = bash
CP       = cp
CP_P     = cp --parents
CLASS_FILES = `find build -name "*class"`

FREGECFLAGS = -hints -O
FREGEC0     = $(JAVA) -Xss16m -Xmx2g -jar $(FREGEJAR) -fp ${BUILD}:${BUILD_TOOLS}
FREGEC      = $(FREGEC0) $(FREGECFLAGS)
FREGE       = $(JAVA) -Xss16m -Xmx2g -cp $(FREGEJAR):${BUILD}:${BUILD_TOOLS}

TESTSDIR = CSPM-Frontend/test
TESTFILES = $(notdir $(wildcard test/*))
TMP = /tmp


cspmf:
	$(MKDIR_P) $(BUILD)
	$(FREGEC) -d build Main.fr


dist: cspmf
	@echo "[1;42mMake $@[0m"
	$(MKDIR_P) $(DIST)
	$(CP_P) $(CLASS_FILES) $(DIST)
	$(MV) $(DIST)/$(BUILD)/* $(DIST)/
	$(RM) $(DIST)/$(BUILD)
	$(CP) $(FREGEJAR) $(DIST)/frege.jar


.PHONY: test %.csp
test: $(TESTFILES)
	@echo $(TESTFILES)
	@echo "[1;42mTesting done[0m"

%.csp:
	@echo "[1;42mTesting $@[0m"
	$(RM) $(TMP)/$@.pl
	./cspmf.sh
	@mv out $(TMP)/out
	diff "test/$@" $(TMP)/out || \
	(echo "Test $@ failed" && exit 1)



.PHONY: clean
clean:
	@echo "[1;42mMaking $@[0m"
	$(RM) $(BUILD_DIRS) $(DIST)
