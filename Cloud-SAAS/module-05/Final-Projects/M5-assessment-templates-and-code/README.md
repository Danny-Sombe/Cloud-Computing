# M5 Assessment App

This app serves a simple upload form and stores metadata in RDS, queues work in SQS, and reads/writes images from S3.

## Requirements

- Node.js 18+ (tested with Node 20)
- AWS credentials available on the host (instance profile or env vars)
- AWS resources created by Terraform in this folder

## Install and run

```bash
npm install
npm start
```

The app listens on port 3000.

## Quick checks

```bash
curl -v http://127.0.0.1:3000/
curl -v http://127.0.0.1:3000/gallery
```
