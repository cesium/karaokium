const hearts = (sources) => {
  const heartPath = document.createElementNS(
    "http://www.w3.org/2000/svg",
    "path"
  );
  heartPath.setAttribute(
    "d",
    "M316.722,29.761c66.852,0,121.053,54.202,121.053,121.041c0,110.478-218.893,257.212-218.893,257.212S0,266.569,0,150.801 C0,67.584,54.202,29.761,121.041,29.761c40.262,0,75.827,19.745,97.841,49.976C240.899,49.506,276.47,29.761,316.722,29.761z"
  );

  const heartShape = document.createElementNS(
    "http://www.w3.org/2000/svg",
    "svg"
  );
  heartShape.setAttribute("viewBox", "0 0 512 512");
  heartShape.setAttribute("height", "20");
  heartShape.setAttribute("width", "20");
  heartShape.appendChild(heartPath);

  return party.scene.current.createEmitter({
    emitterOptions: {
      loops: 1,
      useGravity: false,
      modules: [
        new party.ModuleBuilder()
          .drive("size")
          .by((t) => 0.5 + 0.3 * (Math.cos(t * 10) + 1))
          .build(),
        new party.ModuleBuilder()
          .drive("rotation")
          .by((t) => new party.Vector(0, 0, 100).scale(t))
          .relative()
          .build(),
      ],
    },
    emissionOptions: {
      rate: 0,
      bursts: [{ time: 0, count: party.variation.skew(20, 10) }],
      sourceSampler: party.sources.dynamicSource(sources),
      angle: party.variation.range(0, 360),
      initialSpeed: 200,
      initialColor: party.variation.gradientSample(
        party.Gradient.simple(
          party.Color.fromHex("#ffa68d"),
          party.Color.fromHex("#fd3a84")
        )
      ),
    },
    rendererOptions: {
      shapeFactory: heartShape,
      applyLighting: undefined,
    },
  });
};

export function reactions(sources, emoji) {
  switch (emoji) {
    case "👍":
      party.resolvableShapes["thumbsup"] = `<span>👍</span>`;

      party.confetti(sources, {
        shapes: ["thumbsup"],
        speed: party.variation.range(100, 400),
      });
      break;
    case "❤️":
      hearts(sources);
      break;
    case "⭐️":
      party.sparkles(sources);
      break;
    default:
      party.confetti(sources);
      break;
  }
}
