import createScatterplot from 'regl-scatterplot';

function scatterplot(canvas) {
    const newPlot = createScatterplot({
      canvas,
    });
    
    return newPlot
}

export { scatterplot };
