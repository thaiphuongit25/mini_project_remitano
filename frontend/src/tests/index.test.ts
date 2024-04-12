import Home from "../pages/index";
import "@testing-library/jest-dom";
import { fireEvent, render, screen } from "@testing-library/react";

describe("HomePage", () => {
  it("renders home page", () => {
    render(<Home />);
    // check if all components are rendered
    expect(screen.getByTestId("email")).toBeInTheDocument();
    expect(screen.getByTestId("password")).toBeInTheDocument();
    expect(screen.getByTestId("sign_in")).toBeInTheDocument();
    expect(screen.getByTestId("sign_in")).toBeInTheDocument();
  });
});
