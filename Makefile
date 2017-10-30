build:
	docker build --force-rm=true -t bcl-group/ubuntu-anaconda3-opencv3 .

ps:
	docker ps -a

clean:
	rm *~
