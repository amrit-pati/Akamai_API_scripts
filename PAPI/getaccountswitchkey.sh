read -p "Enter account name search string: " search

echo "Getting account switch Key..."

http -a admin :"/identity-management/v1/open-identities/jfue2isb5qvrgzou/account-switch-keys?search=$search"

echo "Finished..."
