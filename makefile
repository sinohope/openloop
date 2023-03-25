ALL: update 
	git add . && git commit -m "add new" && git push origin main

update:
	git pull origin main
