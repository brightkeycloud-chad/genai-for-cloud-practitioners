### Launch the first EC2 instance with the following details:
- **AMI**: Deep Learning OSS Nvidia Pytorch (Ubuntu)
- **Instance type**: g5g.xlarge (make sure you increase your limit first) - select arm architecture

#### After the instance is launched, SSH and execute the following commands:

    sudo -s
    mkdir ollamawork
    cd ollamawork
    curl -fsSL https://ollama.com/install.sh | sh
    service ollama start
    ollama pull llama3.2
    lspci
    

#### To test the LLM, issue a command similar to the following:

    time curl http://localhost:11434/api/generate -d '{
    "model": "llama3.2",
    "prompt": "Please generate python code to extract DNS records from zones hosted in CloudFlare using their API",
    "stream": false
    }'

**Note**: the end of the output will list the time taken.

#### After this test is complete, launch a second instance:
- **AMI**: Deep Learning Ubuntu (Ubuntu 22.04)
- **Instance type**: m7i.xlarge (same cpu/memory capacity as the first instance)

#### Execute the same test and compare the times

#### When finished, make sure you terminate both instances to avoid excess charges!

