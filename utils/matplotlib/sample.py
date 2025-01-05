import matplotlib.pyplot as plt
from mplext import *

common_graph_style()
nrow = 3
ncol = 3
fig = plt.figure(figsize=(8*ncol, 6*nrow))
ax1 = fig.add_subplot(nrow, ncol, 1)
ax2 = fig.add_subplot(nrow, ncol, 2)
ax3 = fig.add_subplot(nrow, ncol, 3)
ax4 = fig.add_subplot(nrow, ncol, 4)
ax5 = fig.add_subplot(nrow, ncol, 5)
ax6 = fig.add_subplot(nrow, ncol, 6)
ax7 = fig.add_subplot(nrow, ncol, 7)

items = [
    Item('legend1', [0, 1], [50, 55]),
    Item('legend2', [0, 1], [23, 56]),
    Item('legend3', [0, 1], [13, 86]),
]
plot_bar(ax1, items, title='bar', xlabels=[
         'xlabel1', 'xlabel2'], ylabels=['ylabel'])

items = [
    Item('legend1', [0, 1, 2], [50, 55, 59]),
]
plot_bar(ax2, items, title='bar', xlabels=[
         'xlabel1', 'xlabel2', 'xlabel3'], ylabels=['ylabel'])

items = [
    Item('legend1', [0, 1, 2], [50, 55, 59]),
    Item('legend2', [0, 1, 2], [930, 660, 120]),
]
plot_bar(ax3, items, title='bar', xlabels=['xlabel1', 'xlabel2', 'xlabel3'], ylabels=[
         'ylabel1', 'ylabel2'], twinx=True)

items = [
    Item('legend1', [2, 1, 0], [50, 55, 59]),
    Item('legend2', [2, 1, 0], [930, 660, 120]),
    Item('legend3', [2, 1, 0], [130, 360, 220]),
]
plot_barh(ax4, items, title='barh', xlabels=[
          'xlabel1', 'xlabel2', 'xlabel3'], ylabel='ylabel')

items = [
    Item('legend1', [0, 1, 2, 3, 4, 5], [
         10, 11, 13, 20, 40, 70], plot_opts={'marker': 'o'}),
    Item('legend2', [0, 1, 2, 3, 4, 5], [
         50, 100, 200, 100, 10, 1], plot_opts={'marker': 'o'}),
]
plot_line(ax5, items, title='line', xlabel='xlabel', ylabel='ylabel')

items = [
    Item('legend1', None, [10]),
    Item('legend2', None, [90]),
    Item('legend3', None, [200]),
    Item('legend4', None, [700]),
]
plot_pie(ax6, items, title='pie')

items = [
    Item('legend1', [1, 2, 4, 6, 9], [15, 24, 42, 60, 91]),
    Item('legend2', [1, 5, 7, 8, 9], [80, 20, 40, 50, 12]),
]
plot_scatter(ax7, items, title='scatter', xlabel='xlabel', ylabel='ylabel')

fig.tight_layout()
# plt.show()
plt.savefig('fig.png')
