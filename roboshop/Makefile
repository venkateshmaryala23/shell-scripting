help:
	 @IFS=$$'\n' ; \
        help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
        for help_line in $${help_lines[@]}; do \
            IFS=$$'#' ; \
            help_split=($$help_line) ; \
            help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
            help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
            printf "%-15s %s\n" $$help_command $$help_info ; \
        done

git-pull:
	@echo ------+pulling git code+------
	@git pull &>>/dev/null

cart: git-pull ## Setup Cart Component
	@bash components/cart.sh

catalogue: git-pull ## Setup catalogue component
	@bash components/catalogue.sh

user: git-pull ## Setup user component
	@bash components/user.sh

shipping: git-pull ## Setup shipping component
	@bash components/shipping.sh

payment: git-pull ## Setup payment component
	@bash components/payment.sh

frontend: git-pull ## Setup frontend component
	@bash components/frontend.sh

mysql: git-pull ## Setup MySQL component
	@bash components/mysql.sh

redis: git-pull ## Setup Redis component
	@bash components/redis.sh

rabbbitmq: git-pull ## Setup Rabbitmq component
	@bash components/rabbitmq.sh

mongodb: git-pull ## Setup Mongodb component
	@bash components/mongodb.sh



