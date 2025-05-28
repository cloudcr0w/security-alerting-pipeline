# 🔧 Ansible – AWS CLI Automation

This folder contains an Ansible playbook and role that installs and configures AWS CLI v2 on a Linux system.  
It simulates real-world configuration management using Ansible.

- **Target:** local machine (`localhost`)
- **Action:** Download, install and configure AWS CLI v2

---

## 📦 Role: `awscli`

This role installs and configures AWS CLI v2.

### 🔧 Variables

| Variable         | Description                         |
|------------------|-------------------------------------|
| `aws_access_key` | AWS access key ID                   |
| `aws_secret_key` | AWS secret access key               |
| `aws_region`     | Default region for AWS CLI config   |

---

### ▶️ Example Usage

```yaml
- hosts: localhost
  become: yes
  roles:
    - role: awscli
      vars:
        aws_access_key: "YOUR_ACCESS_KEY"
        aws_secret_key: "YOUR_SECRET_KEY"
        aws_region: "us-east-1"
```

### 🏷️ Tags
This role supports the following tags:

awscli

install

configure