HTMLWidgets.widget({

  name: 'rscatter',

  type: 'output',

  factory: function(el, width, height) {

    const canvas = document.createElement('canvas');
    canvas.id = 'canvas';
    el.appendChild(canvas);

    var plot = rscatter.scatterplot(canvas)

    return {

      renderValue: function(x) {

        plot.draw({
          x: x.points.x,
          y: x.points.y,
          valueA: x.points.valueA
        })
        plot.set({
          keyMap: {},
        })
        plot.set({
          // TODO: disable point hover color change?
          pointColorHover: "#000000",
          pointColor: x.options.color,
          pointSize: x.options.size,
          colorBy: x.options.colorBy,
        })

        if (x.options.opacity) {
          plot.set({
            opacity: x.options.opacity,
          })
        } else {
          plot.set({
            opacityBy: "density",
          })
        }

      },

      resize: function(width, height) {

        plot.set({ width, height });

      },

      plot: plot

    };
  }
});
