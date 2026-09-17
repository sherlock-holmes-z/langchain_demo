"""集中管理本地环境变量的加载与校验。"""

from __future__ import annotations

import os
from pathlib import Path

from dotenv import load_dotenv

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_ENV_FILE = PROJECT_ROOT / ".env"


def load_project_environment(
    env_file: Path = DEFAULT_ENV_FILE,
    *,
    override: bool = False,
) -> bool:
    """加载明确指定的环境文件，避免 Notebook 工作目录影响查找结果。"""
    return load_dotenv(dotenv_path=env_file, override=override)


def require_environment_variable(name: str) -> str:
    """读取必需环境变量；缺失时返回不含敏感信息的明确错误。"""
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"缺少环境变量 {name}，请根据 .env.example 配置项目根目录 .env")
    return value
