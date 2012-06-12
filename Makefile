CXXFLAGS := -g -W -Wall -pedantic -O3 -ffast-math 
LFLAGS   := -g

OSUPPER = $(shell uname -s 2>/dev/null | tr  [:lower:] [:upper:])
# 'linux' is output for Linux system, 'darwin' for OS X
DARWIN = $(strip $(findstring DARWIN, $(OSUPPER)))
ifneq ($(DARWIN),)
	CXXFLAGS += -Wno-long-long -arch x86_64 -msse3
	LFLAGS   += -arch x86_64 -framework OpenCL
else
	LFLAGS   += -lOpenCL -lpthread
	EXT_INCS += -I.
endif

.SUFFIXES: .cpp
.SUFFIXES: .o
.cpp.o:
	$(CXX) $(CSOFLAGS) $(CXXFLAGS) $(EXT_INCS)  -c $< -o $*.o

PROGRAMS = functionLocalStaticCost

default: $(PROGRAMS)

FUNCTIONLOCALSTATICCOST_LIBS = functionLocalStaticCost.o 
functionLocalStaticCost: $(FUNCTIONLOCALSTATICCOST_LIBS)
	$(CXX) $(FUNCTIONLOCALSTATICCOST_LIBS) $(LFLAGS) -o $@ $(LIBS)

clean: 
	$(RM) $(PROGRAMS) *.o
