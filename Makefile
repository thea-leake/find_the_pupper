DEP_PACKAGES = collections-lib pvector
deps:
	raco pkg install  --skip-installed  $(DEP_PACKAGES)
