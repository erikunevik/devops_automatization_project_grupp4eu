from weather_app.graph import graph
import pandas as pd
import plotly.graph_objects as go # go = go.data & go.layout

test_data = pd.DataFrame(
    dict(time=["00:00", "01:00", "02:00"],
            degree=[5,6,7]))

def test_graph_returns_fig_object():
    result = graph(test_data)

    assert isinstance(result, go.Figure)

def test_graph_has_correct_data():
    result = graph(test_data)

    assert list(result.data[0].x) == ["00:00", "01:00", "02:00"]
    assert list(result.data[0].y) == [5,6,7]

def test_graph_layout():
    result= graph(test_data)
    
    assert result.layout.title.text == "Vädret för de kommande 24 timmarna"
    assert result.layout.xaxis.title.text == "Tid (hh:mm)"
    assert result.layout.yaxis.title.text == "Temperatur (°C)" 
    
