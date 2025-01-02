import matplotlib.pyplot as plt
from mplext import *

common_graph_style()
nrow = 3
ncol = 2
fig = plt.figure(figsize=(8*ncol, 6*nrow))
ax1 = fig.add_subplot(nrow, ncol, 1)
ax2 = fig.add_subplot(nrow, ncol, 2)
ax3 = fig.add_subplot(nrow, ncol, 3)
ax4 = fig.add_subplot(nrow, ncol, 4)
ax5 = fig.add_subplot(nrow, ncol, 5)

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
    Item('legend1', [0, 1, 2, 3, 4, 5], [
         10, 11, 13, 20, 40, 70], plot_opts={'marker': 'o'}),
    Item('legend2', [0, 1, 2, 3, 4, 5], [
         50, 100, 200, 100, 10, 1], plot_opts={'marker': 'o'}),
]
plot_line(ax4, items, title='line', xlabel='xlabel', ylabel='ylabel')

items = [
    Item('legend1', None, [10]),
    Item('legend2', None, [90]),
    Item('legend3', None, [200]),
    Item('legend4', None, [700]),
]
plot_pie(ax5, items, title='pie')

fig.tight_layout()
# plt.show()
plt.savefig('fig.png')
