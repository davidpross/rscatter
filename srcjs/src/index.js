import createScatterplot from 'regl-scatterplot';

function scatterplot(canvas, width, height) {
    const newPlot = createScatterplot({
      canvas,
      width,
      height,
    });
    
    return newPlot
}

export { scatterplot };
