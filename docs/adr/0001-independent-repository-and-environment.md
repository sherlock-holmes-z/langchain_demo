---
status: accepted
---

# 使用独立仓库及 Conda 与 uv 双层环境管理

LangChain 学习内容放在独立的 `langchain_demo` 仓库中，避免其快速变化的依赖影响已有 Python 学习项目。Conda 只负责 Python 3.12 解释器隔离，项目直接依赖由 `pyproject.toml` 声明，完整依赖图由 `uv.lock` 固定；这样既保留 Conda 的环境隔离能力，也避免在多个配置文件中重复维护 Python 包版本。
