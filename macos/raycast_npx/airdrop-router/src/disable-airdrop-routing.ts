import { showHUD, updateCommandMetadata } from "@raycast/api";
import { disableRouting } from "./config";

export default async function Command() {
  await disableRouting();
  await updateCommandMetadata({ subtitle: "Routing disabled" });
  await showHUD("AirDrop routing disabled — new transfers stay in Downloads");
}
