# Variables
DB=enceladus
CSV='${CURDIR}/data/master_plan.csv'
BUILD=${CURDIR}/build.sql

SCRIPTS=${CURDIR}/scripts
MASTER=$(SCRIPTS)/import.sql
NORMALIZE=$(SCRIPTS)/normalize.sql
VIEWS=$(SCRIPTS)/views.sql

# default target
# will execute if you don't specify a targen when executing the make command
all: views
	psql $(DB) -f $(BUILD)

master:
	@cat $(MASTER) >> $(BUILD)

import: master # import depends on master
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

normalize: import # normalize depends on import
	@cat $(NORMALIZE) >> $(BUILD)

views : normalize
	@cat $(VIEWS) >> $(BUILD)

clean:
	@rm -rf $(BUILD)

