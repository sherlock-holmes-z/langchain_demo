---
status: accepted
---

# 使用独立仓库及 Conda 环境管理

LangChain 学习内容放在独立的 `langchain_demo` 仓库中，避免其快速变化的依赖影响已有 Python 学习项目。项目统一使用名为 `langchain-demo` 的 Conda 环境，运行依赖和开发工具由 `environment.yml` 安装，项目元数据与工具配置保留在 `pyproject.toml`。不再使用 uv，也不在项目目录创建额外的 `.venv`。
