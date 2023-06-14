Setup in this order:

1. panel
    - (Database / Cache / Panel)
    - Once running, use
    `sudo docker-compose run --rm panel php artisan p:user:mak` to create the admin user
2. Wings
    - Setup wings per 'node' to use with pterodactyl
    - Spin up docker container on Wing host with compose file
    - Create a location in panel
    - Create a Node in panel
        - After creation of node
        - Go to Node Name --> Configuration Tab
        - Get Configuration file
            - Copy it into /etc/pterodactyl/config.yml on Wing host
        - Re-create docker container for wing
    - Make sure Connection is good 'green-heart' in pterodactyl panel
