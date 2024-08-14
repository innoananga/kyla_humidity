double percentageRecalculation(double inputPercentage) {
  inputPercentage = inputPercentage.clamp(0, 100);

  final List<double> inputValues = [0, 11.1, 22.2, 33.3, 44.4, 55.5, 66.6, 77.7, 88.8, 100];
  final List<double> outputValues = [0, 10, 25, 30, 35, 40, 45, 50, 75, 100];

  for (int i = 0; i < inputValues.length - 1; i++) {
    if (inputPercentage >= inputValues[i] && inputPercentage <= inputValues[i + 1]) {
      double t = (inputPercentage - inputValues[i]) / (inputValues[i + 1] - inputValues[i]);
      return outputValues[i] + t * (outputValues[i + 1] - outputValues[i]);
    }
  }

  return inputPercentage <= 0 ? outputValues.first : outputValues.last;
}
