cat <<'EOF' > app.sh
#!/bin/bash

cd /home/Mahesh

apt-get update -y

apt-get install nginx -y
apt-get install nodejs -y  
apt-get install npm -y
apt-get install git -y

git clone https://github.com/Mahesh-65/Fitness_Tracker.git

cat <<EOF > /etc/nginx/sites-available/custom
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://localhost:5000;
    }
}
EOF

ln -s /etc/nginx/sites-available/custom /etc/nginx/sites-enabled/
cd /etc/nginx/sites-enabled
rm -rf default

systemctl restart nginx

cd /home/Mahesh/Fitness_Tracker/server

cat <<EOF > .env
PORT=5000
MONGODB_URI=mongodb+srv://Mahesh:Data%40050903@mahesh-cosmos-db.global.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000
EOF

npm install -g pm2

pm2 start app.js --name "fitness-app"
pm2 save
pm2 startup
EOF
