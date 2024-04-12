import Share from "../pages/share/index";
import "@testing-library/jest-dom";
import { fireEvent, render, screen } from "@testing-library/react";

describe("Share", () => {
  it("renders share page", () => {
    render(<Share />);
    // check if all components are rendered
    expect(screen.getByTestId("youtube-url")).toBeInTheDocument();
    expect(screen.getByTestId("btn_share")).toBeInTheDocument();
  });
});
