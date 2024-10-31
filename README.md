This script is created by me (qking)
Pls give credits if you modify

This script limits cpu so for example your vps doesnt get killed while accedentaly using more cpu

# Curl the input script and execute it
curl -s -o /tmp/input.sh https://raw.githubusercontent.com/QKing-Official/cpulimiter/main/input.sh && \
bash /tmp/input.sh && \
# Curl the install script and execute it
curl -s -o /tmp/install.sh https://raw.githubusercontent.com/QKing-Official/cpulimiter/main/install.sh && \
sudo bash /tmp/install.sh

