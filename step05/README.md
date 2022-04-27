# STEP05 - Push producer logs to Opensearch
  
![Step05](images/step05.png)

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/raclepoulpe/twifka/tree/main/step05)

## Create new OVHcloud managed Opensearch

According this tutorial https://docs.ovh.com/gb/en/publiccloud/databases/opensearch/getting-started/:

- Subscribe to a new Managed Opensearch service, and name it <span style="color: orange;">**my-managed-opensearch**</span>

## Manage Gitpod variables

![Step05 Opensearch hostname](images/step05_01.png)

$ echo "opensearch-a1b2c3d4-abcde12345.database.cloud.ovh.net" | base64
b3BlbnNlYXJjaC1hMWIyYzNkNC1hYmNkZTEyMzQ1LmRhdGFiYXNlLmNsb3VkLm92aC5uZXQK

$ echo "avnadmin" | base64
YXZuYWRtaW4K

![Step05 Opensearch password reset](images/step05_02.png)

![Step05 Opensearch password reset result](images/step05_03.png)

$ echo "mygivenpassword" | base64
bXlnaXZlbnBhc3N3b3JkCg==

![Step05 Gitpod Variables](images/step05_04.png)

- OPENSEARCH_HOST_B64
- OPENSEARCH_USER_B64
- OPENSEARCH_PWD_B64

## Opensearch Dashboard

### Dev Tools

![Step05 Opensearch Dashboard Dev Tools](images/step05_05.png)

```
PUT /twifka

GET /twifka

PUT /twifka/_doc/1
{
  "demo":"twitch"
}

GET /twifka/_doc/1

GET /twifka/_search
{
  "query": {
    "match": { "demo":"twitch"
    }
  }
}

PUT /twifka_producer_logs
```


