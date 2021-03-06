CXX ?= c++

CFLAGS += -Iext/jsoncpp/include -Isrc -std=c++0x -m64 -Os
LDFLAGS += -lcrypto -lpng -lboost_filesystem -lboost_system -lboost_program_options -lz
OBJS = obj/ext/jsoncpp/src/jsoncpp.o obj/src/packet.o obj/src/parser.o obj/src/main.o obj/src/image_writer.o obj/src/json_writer.o obj/src/game.o obj/src/image_util.o
WOT_INSTALL_PATH = /media/windows/Games/World_of_Tanks
MAPS = maps/no-border/01_karelia.png maps/no-border/02_malinovka.png maps/no-border/03_campania.png maps/no-border/04_himmelsdorf.png maps/no-border/05_prohorovka.png maps/no-border/06_ensk.png maps/no-border/07_lakeville.png maps/no-border/08_ruinberg.png maps/no-border/10_hills.png maps/no-border/11_murovanka.png maps/no-border/13_erlenberg.png maps/no-border/14_siegfried_line.png maps/no-border/15_komarin.png maps/no-border/17_munchen.png maps/no-border/18_cliff.png maps/no-border/19_monastery.png maps/no-border/22_slough.png maps/no-border/23_westfeld.png maps/no-border/28_desert.png maps/no-border/29_el_hallouf.png maps/no-border/31_airfield.png maps/no-border/33_fjord.png maps/no-border/34_redshire.png maps/no-border/35_steppes.png maps/no-border/36_fishing_bay.png maps/no-border/37_caucasus.png maps/no-border/38_mannerheim_line.png maps/no-border/39_crimea.png maps/no-border/42_north_america.png maps/no-border/44_north_america.png maps/no-border/45_north_america.png maps/no-border/47_canada_a.png maps/no-border/51_asia.png

default: all
	echo Built $(OBJS)

obj:
	@mkdir -p obj

obj/%.o: %.cpp
	@echo Building $@ from $<
	@mkdir -p $(dir $@)
	$(CXX) $(CFLAGS) -c -o $@ $<

all: obj $(OBJS)
	$(CXX) $(CFLAGS) $(LDFLAGS) -o obj/wotreplay-parser $(OBJS)

clean:
	@rm -rf obj gui maps

run: all
	mkdir -p out/positions out/deaths
	@./obj/wotreplay-parser

%.pkg: 
	@cp $(WOT_INSTALL_PATH)/res/packages/$@ ./

spaces/%/mmap.dds: %.pkg
	@mkdir -p maps/no-border
	@unzip -o $< spaces/$(basename $<)/mmap.dds > /dev/null
	@rm -f $<

maps/no-border/%.png: spaces/%/mmap.dds
	@convert -size 512x512 $< -alpha on -resize 512x512 $@
	@echo Generated $@
	@rm -f $<

minimaps: $(MAPS)
	@rm -rf gui

