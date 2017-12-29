from sklearn.linear_model import LinearRegression
import pandas
import coremltools

data = pandas.read_csv("cars_with_batteries.csv")

model = LinearRegression()
model.fit(data[["model", "premium", "mileage", "condition", "battery"]], data["price"])

coreml_model = coremltools.converters.sklearn.convert(model, ["model", "premium", "mileage", "condition", "battery"], "price")

coreml_model.author = "Nic Ollis"
coreml_model.license = "MIT"
coreml_model.short_description = "Predicts the trade-in price of a Tesla"

coreml_model.save("Cars.mlmodel")
