import matplotlib.pyplot as plt
from matplotlib.axes import Axes
import numpy as np
import seaborn as sns
from typing import Union


class Item():
    legend: str
    x: list[Union[int, float]]
    y: list[Union[int, float]]
    plot_opts: dict

    def __init__(self, legend, x, y, plot_opts=dict()):
        self.legend = legend
        self.x = x
        self.y = y
        self.plot_opts = plot_opts


def common_graph_style():
    sns.set()
    sns.set_style("whitegrid", {'grid.linestyle': '--'})
    sns.set_context("notebook", 1.5, {"lines.linewidth": 4})
    sns.set_palette("colorblind")


def plot_bar(
        ax: Axes, items: list[Item],
        title: str = None, xlabels: list[str] = None, ylabels: list[str] = None, twinx: bool = False):
    w = 1.0 / (len(items)+1)
    handles = []

    if twinx is True:
        assert len(items) == 2
        assert len(ylabels) == 2
    else:
        assert len(ylabels) == 1

    if twinx is False:
        for i, item in enumerate(items):
            handle = ax.bar(np.array(item.x) + (w*i), item.y,
                            width=w, label=item.legend, **item.plot_opts)
            handles.append(handle)
        if ylabels is not None:
            ax.set_ylabel(ylabels[0])
    else:
        palette = sns.color_palette()
        handle = ax.bar(np.array(items[0].x), items[0].y,
                        width=w, color=palette[0], label=items[0].legend, **items[0].plot_opts)
        handles.append(handle)
        ax.set_ylabel(ylabels[0])
        ax2 = ax.twinx()
        handle = ax2.bar(np.array(items[1].x) + w, items[1].y,
                         width=w, color=palette[1], label=items[1].legend, **items[1].plot_opts)
        handles.append(handle)
        ax2.set_ylabel(ylabels[1])
        ax2.grid(False)

        ax_yticklocs = ax.yaxis.get_majorticklocs()
        ax2_yticklocs = ax2.yaxis.get_majorticklocs()
        assert ax_yticklocs[0] == 0
        assert ax2_yticklocs[0] == 0
        ax_yticklocs_diff = ax_yticklocs[1]
        ax2_yticklocs_diff = ax2_yticklocs[1]
        yticklocs_num = max([len(ax_yticklocs), len(ax2_yticklocs)])
        ax.set_ylim(ax_yticklocs[0], ax_yticklocs_diff * (yticklocs_num - 1))
        ax2.set_ylim(ax2_yticklocs[0],
                     ax2_yticklocs_diff * (yticklocs_num - 1))

    if xlabels is not None:
        assert len(xlabels) == len(items[0].x)
        ax.set_xticks(np.array(items[0].x) + w*len(items)/2 - w/2, xlabels)

    ax.legend(handles=handles, loc='upper center',
              bbox_to_anchor=(0.5, -0.15), ncol=2)

    if title is not None:
        ax.set_title(title)


def plot_barh(
        ax: Axes, items: list[Item],
        title: str = None, xlabels: list[str] = None, ylabel: str = None):
    normalized_y = [np.array(item.y) for item in items]
    normalized_y /= sum(normalized_y)
    normalized_y *= 100
    cumulative_y = np.cumsum(normalized_y, axis=0)

    for i, item in enumerate(items):
        ax.barh(item.x, cumulative_y[i], label=item.legend, zorder=(
            len(items) - i), **item.plot_opts)

    if xlabels is not None:
        ax.set_yticks(items[0].x, xlabels)

    if ylabel is not None:
        ax.set_xlabel(ylabel)

    ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2)

    if title is not None:
        ax.set_title(title)


def plot_line(
        ax: Axes, items: list[Item],
        title: str = None, xlabel: str = None, ylabel: str = None):
    for item in items:
        ax.plot(item.x, item.y, label=item.legend, **item.plot_opts)

    if xlabel is not None:
        ax.set_xlabel(xlabel)

    if ylabel is not None:
        ax.set_ylabel(ylabel)

    ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2)

    if title is not None:
        ax.set_title(title)


def plot_pie(
        ax: Axes, items: list[Item],
        title: str = None, sort: bool = True):
    for item in items:
        assert len(item.legend) is not None
        assert len(item.y) == 1

    if sort == True:
        items = sorted(items, key=lambda i: i.y[0], reverse=True)

    data = [item.y[0] for item in items]
    ax.pie(data, counterclock=False, startangle=90,
           autopct=lambda p: '{:.1f}%'.format(p) if p >= 10 else '',
           textprops={'color': 'white'})

    legends = [f'{item.legend}: {item.y[0]}' for item in items]
    ax.legend(legends, loc='center left', bbox_to_anchor=(1, 0.5), ncol=1)

    if title is not None:
        ax.set_title(title)
