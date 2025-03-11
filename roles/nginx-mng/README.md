# Nginx管理角色文档

## 角色概述
本Ansible角色提供完整的Nginx服务生命周期管理功能，支持：
- 标准编译安装流程
- 版本升级与回滚机制
- 多主机多实例安装配置管理
- 配置版本控制(依赖于git版本控制)

## 目录结构
```
nginx-mng/
├── defaults/          # 默认变量配置
│   └── main.yml
├── handlers/         # 处理器定义
│   └── main.yml
├── tasks/            # 主任务流程
│   ├── main.yml
│   ├── install_dependencies.yml  # 依赖安装
│   ├── compile_install.yml       # 编译安装
│   ├── rollback_nginx.yml        # 版本回滚
│   └── upgrade_nginx.yml         # 版本升级
└── templates/        # 配置模板
    ├── nginx.conf.j2
    ├── nginx.service.j2
    ├── web1-nginx.conf.j2
    └── web2-nginx.conf.j2
```

## 变量配置 (defaults/main.yml)
```yaml
nginx_version: "1.25.3"             # 初始安装版本
nginx_install_dir: "/usr/local/nginx" # 安装根目录
nginx_upgrade: false                # 升级开关
nginx_rollback: false               # 回滚开关
nginx_new_version: "1.25.4"         # 目标升级版本
nginx_current_version: "{{ lookup('file', nginx_install_dir + '/' + inventory_hostname + '/current_version') | trim }}" # 自动获取当前版本
```

## 核心任务说明

### 标准安装流程
1. **依赖安装**：安装gcc/make等编译工具
2. **用户配置**：创建nginx系统用户和日志目录
3. **编译安装**：
   - 下载指定版本源码
   - 配置编译参数（SSL/线程/状态模块）
   - 执行make && make install
4. **服务配置**：
   - 生成systemd服务单元文件
   - 配置多实例支持

### 升级流程
1. 版本校验
   - 检查新版本号格式有效性
   - 验证新版本必须高于当前版本
2. 备份当前版本
3. 下载新版本源码
4. 并行安装新版本
5. 平滑切换版本
6. 保留回滚能力

### 回滚机制
1. 检查备份元数据
2. 版本校验
   - 验证备份版本必须低于当前版本
3. 停止当前服务
4. 恢复旧版本文件
5. 更新版本记录
6. 重启服务

### 新增验证逻辑
1. 升级前检查：
   - 目标版本 > 当前版本
   - 版本号符合语义化规范
2. 回滚前检查：
   - 备份版本 < 当前版本
   - 备份文件完整性验证

## 使用示例
```yaml
# 标准安装
- hosts: webservers
  roles:
    - role: nginx-mng

# 版本升级
- hosts: webservers
  vars:
    nginx_upgrade: true
    nginx_new_version: "1.25.4"
  roles:
    - role: nginx-mng

# 版本回滚
- hosts: webservers
  vars:
    nginx_rollback: true
  roles:
    - role: nginx-mng
```

## 注意事项
1. 升级前确保目标版本checksum校验通过
2. 回滚操作依赖之前的备份文件
3. 多实例配置需配合模板文件使用