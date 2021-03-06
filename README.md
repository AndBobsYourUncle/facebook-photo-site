# Facebook Photo Site

This is a complete solution that can be deployed on a cloud server relatively easily. Once deployed, emails for Facebook admins are read in from an environment variable, and admin access is granted to anyone that signs in via Facebook that has a matching email.

Friends of any of the admins are allowed to view the main site, whereas non-friends are shown a different homepage. This can enable you to have a fully-stylized website that hosts all the images you want to share, and it is only viewable to friends.

In addition, individual Facebook users can either be added to a whitelist or blacklist. This can enable you to block the site from being viewable to certain friends, or enable you to share the site with people who are not Facebook friends with any admins.

To get this deployed to a production server, you can follow this quick guide based on Digital Ocean (and using AWS S3 for image storage):

### AWS Setup

1. Create a new group in your security credentials area, and give the group AmazonS3FullAccess privileges. Then create a new user in that group, and generate a new access key and secret. Note those down.
2. Create a new S3 bucket, with that new user as the owner. Just leave it on private, only viewable with credentials. Note down the bucket name, region, and host.

### FB Setup

1. Go to https://developers.facebook.com/apps/ and create a new app.
2. Add a product to the app, and pick "Facebook Login".
3. Choose the one for "web," click the save button, and then switch the the settings for that product and for the OAuth callback enter in: `https://[DOMAIN OF SITE]/users/auth/facebook/callback`

### Digital Ocean setup

1. Create a new Digital Ocean droplet and all the networking to get the domain pointed to it via the networking options. Use a Ubuntu installation. For this server to run without crashing due to the memory limit, you'll need at least 4 GB of RAM for the droplet.
2. On the fresh Ubuntu droplet, you can follow this doc to get it completely set up: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04
3. Follow this guide to setup Docker on the droplet: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
4. Install docker-compose on the server: https://docs.docker.com/compose/install/#install-compose
5. Git clone this repository on the server.
6. Run `rails secret` and note down the key. If you'd like more security for the image server, do this twice and save both keys.
7. Edit your bash profile to add all necessary enviroment variables. Run `sudo nano /etc/profile` and add the following lines to the end:
```
export FB_PHOTO_SITE_SECRET_KEY_BASE=[KEY FROM STEP 6 ABOVE]
export FB_PHOTO_SITE_HOSTNAME=[YOUR DOMAIN NAME]
export FB_PHOTO_SITE_EMAIL=[YOUR EMAIL]
export THUMBOR_KEY=[KEY FROM STEP 6 ABOVE]

export FB_APP_ID=[FB APP ID]
export FB_APP_SECRET=[FB APP SECRET]
export FB_PHOTO_SITE_ADMINS=[COMMA-SEPARATED LIST OF ADMIN EMAILS]

export S3_BUCKET_NAME=[AWS BUCKET NAME]
export AWS_ACCESS_KEY_ID=[AWS ACCESS KEY]
export AWS_SECRET_ACCESS_KEY=[AWS SECRET ACCESS KEY]
export AWS_REGION=[AWS REGION]
export AWS_HOST_NAME=[AWS HOSTNAME]
```
8. After modifying your profile, you will need to restart the server.
7. Run `docker compose up -d` inside this repo's folder.

Your app should be up and running. If you login to your site, and your Facebook email is in the list from step #7 above, then you should see and "admin" link where you can upload images and manage the albums.
