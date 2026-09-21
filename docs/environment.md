# 环境与配置说明

## 固定版本

| 组件 | 版本 | 用途 |
| --- | --- | --- |
| Python | 3.12 | 当前 AI 生态兼容性较稳定的解释器版本 |
| LangChain | 1.4.0 | Agent、Middleware 和模型编排 |
| langchain-deepseek | 1.1.0 | `ChatDeepSeek` 专用集成 |
| langchain-openai | 1.6.2 | OpenAI API 风格的 LangChain 基础适配 |
| OpenAI SDK | 3.14.1 | 直接调用 DeepSeek 的 OpenAI 兼容接口 |
| python-dotenv | 1.2.3 | 本地 `.env` 加载 |
| ipykernel | 7.3.0 | VS Code/Jupyter Kernel |

运行依赖和开发工具的版本固定在 `environment.yml`，项目元数据中的直接依赖同步记录在
`pyproject.toml`。升级时应同时修改两处直接依赖版本并执行完整验证。

## 配置文件职责

| 文件 | 是否提交 | 职责 |
| --- | --- | --- |
| `environment.yml` | 是 | 创建 `langchain-demo` Conda 环境并安装运行、开发依赖 |
| `pyproject.toml` | 是 | 声明直接依赖、Python 范围和质量工具配置 |
| `.env.example` | 是 | 环境变量模板，不包含密钥 |
| `.env` | 否 | 本机真实密钥，由 `.gitignore` 排除 |

## 环境变量

```dotenv
DEEPSEEK_API_KEY=
DEEPSEEK_API_BASE=https://api.deepseek.com
```

`ChatDeepSeek` 自动读取 `DEEPSEEK_API_KEY` 和 `DEEPSEEK_API_BASE`。不要使用容易混淆的
`DEEPSEEK_BASE_URL`；如果必须使用其他变量名，应在代码中显式传入 `base_url`。

配置优先级遵循：部署平台或当前进程注入的环境变量高于本地 `.env`。因此项目加载配置时默认使用
`override=False`，避免本地文件覆盖 CI/CD、容器或生产环境注入的值。

## 换电脑恢复环境

```powershell
git clone <repository-url> langchain_demo
Set-Location langchain_demo
Copy-Item .env.example .env
.\scripts\bootstrap.ps1
conda activate langchain-demo
pytest
```

仓库当前不配置远程地址，首次推送前需要自行创建远程仓库并执行 `git remote add origin ...`。

## 依赖升级流程

1. 在独立分支同步修改 `environment.yml` 和 `pyproject.toml` 中的直接依赖版本。
2. 执行 `conda env update --name langchain-demo --file environment.yml --prune` 更新环境。
3. 执行 Ruff、mypy、pytest 和 Notebook 静态检查。
4. 如需在线验证，显式使用测试账号和费用限额执行。
5. 检查配置文件差异后再提交。
