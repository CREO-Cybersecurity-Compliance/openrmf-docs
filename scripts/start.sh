# pull down the most recent :latest tags
docker pull cingulara/openrmf-web:0.8
docker pull cingulara/openrmf-api-read:0.8
docker pull cingulara/openrmf-api-save:0.8
docker pull cingulara/openrmf-api-upload:0.8
docker pull cingulara/openrmf-api-scoring:0.8
docker pull cingulara/openrmf-msg-score:0.8
docker pull cingulara/openrmf-msg-compliance:0.8
docker pull cingulara/openrmf-msg-controls:0.8
docker pull cingulara/openrmf-msg-checklist:0.8
docker pull cingulara/openrmf-api-template:0.8
docker pull cingulara/openrmf-api-compliance:0.8
docker pull cingulara/openrmf-api-controls:0.8
docker pull nats:1.4.1-linux
docker pull mongo:4.0.5

# Now run the latest development openRMF stack
docker-compose up -d

# tell them the URL
echo ''
echo 'Run http://{ip-address}:8080/ to access OpenRMF'
echo ''
