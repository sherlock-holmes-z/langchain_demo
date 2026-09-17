"""项目配置加载测试，不访问任何真实模型 API。"""

from pathlib import Path

import pytest

from langchain_demo.config import DEFAULT_ENV_FILE, PROJECT_ROOT, load_project_environment, require_environment_variable


def test_default_env_file_is_in_project_root() -> None:
    assert DEFAULT_ENV_FILE == PROJECT_ROOT / ".env"


def test_load_project_environment_from_explicit_file(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    variable_name = "LANGCHAIN_DEMO_TEST_KEY"
    monkeypatch.delenv(variable_name, raising=False)
    env_file = tmp_path / ".env"
    env_file.write_text(f"{variable_name}=configured\n", encoding="utf-8")

    assert load_project_environment(env_file)
    assert require_environment_variable(variable_name) == "configured"


def test_require_environment_variable_rejects_missing_value(monkeypatch: pytest.MonkeyPatch) -> None:
    variable_name = "LANGCHAIN_DEMO_MISSING_KEY"
    monkeypatch.delenv(variable_name, raising=False)

    with pytest.raises(RuntimeError, match=variable_name):
        require_environment_variable(variable_name)
