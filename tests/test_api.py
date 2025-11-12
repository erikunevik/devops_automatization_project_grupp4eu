from weather_app.extract_data import get_weather_data, create_dict
import pytest

def test_get_weather_data_is_dict():
    test_data = get_weather_data("stockholm")
    assert isinstance(test_data, dict)

def test_get_weather_data_no_exception():
    try:
        test_data = get_weather_data("stockholm")
        assert True
    except Exception as e: 
        pytest.fail(f"Unexpected exception: {e}")

def test_df_structure(): 
    test_data = create_dict("malmö")

    assert len(test_data) == 24
    assert list(test_data.columns) == ["time", "degree"]