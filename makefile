ALL:
	redoc-cli build openapi.yaml --options theme.json -o index.html
	git add . && git commit -m "add new" && git push origin main