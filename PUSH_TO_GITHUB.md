# 推送到 GitHub（本机/集群需登录）

当前仓库已在 **`/home/ray/default/Storage_repo`** 完成 **`git commit`**（含 Git LFS 指针），但 **`git push` 需要你的凭据**，云端无法代你登录。

## 推荐：依次上传（每个压缩包一次提交）

仓库已按 **由小到大** 拆成 **8 个提交**（README + 7 个 `folder_*.tar.gz`）+ **1 个脚本提交**。在 **`Storage_repo`** 目录执行：

```bash
export GITHUB_TOKEN=ghp_你的_PAT
bash sequential_push.sh
```

脚本会 **按顺序** 把每个 commit 推到 `main`（便于中途失败时从断点继续；LFS 会随对应提交上传）。

---

任选一种方式：

## 1. HTTPS + Personal Access Token（推荐）

在 GitHub：**Settings → Developer settings → Personal access tokens**，创建带 **`repo`** 权限的 token。

```bash
cd /home/ray/default/Storage_repo
git remote -v   # 应为 https://github.com/GinsengHoney/Storage.git
git push -u origin main
# 用户名：GinsengHoney
# 密码：粘贴 token（不是账户密码）
```

或临时写入远程（**勿把含 token 的命令提交到公开仓库**）：

```bash
git push https://GinsengHoney:<YOUR_TOKEN>@github.com/GinsengHoney/Storage.git main
```

## 2. SSH

将本机公钥加到 GitHub SSH keys，然后把 `origin` 改为 SSH 再 `git push`：

```bash
git remote set-url origin git@github.com:GinsengHoney/Storage.git
git push -u origin main
```

## 3. Git LFS 与额度

- 超过 **100MB** 的文件必须用 **Git LFS**（本仓库已 `git lfs track "*.tar.gz"`）。
- GitHub 免费账号 **LFS 存储/流量约 1GB/月**；本批压缩包合计约 **2.5GB**，若 push 报 LFS 额度错误，需在 GitHub **Billing → LFS** 扩容，或改用 **Release 资源 / 对象存储** 存最大包。

克隆带 LFS 的仓库时：

```bash
git lfs install
git clone https://github.com/GinsengHoney/Storage.git
cd Storage && git lfs pull
```
