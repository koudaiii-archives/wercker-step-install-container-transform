install-container-transform
---



Usage
---

```wercker.yml
deploy:
  steps:
    - koudaiii/install-container-transform:
      key: $AWS_KEY
      secret: $AWS_SECRET
      region: $AWS_REGION
      cluster: $AWS_ECS_CLUSTER
```
