// Windows
import { Bar } from "./modules/bar/bar.js";
import { Dashboard } from "./modules/dashboard/dashboard.js";
import { Calendar } from "./modules/dashboard/calendar.js";

// SCSS Output Directory
const styleDir = '/tmp/ags-style.css';

// Apply css
const applyScss = () => {
  // Compile scss
  const out = Utils.exec(
    `sass ${App.configDir}/scss/main.scss ${styleDir} --style=compressed`,
  );
  console.log(out.length === 0 ? "SCss Compiled" : `Error compiling SCSS:\n ${out}`);

  // Apply compiled css
  App.resetCss();
  App.applyCss(styleDir);
  console.log("Compiled css applied");
};

// Apply css then check for changes
applyScss();

// Main config
App.config({
    style: styleDir,
    windows: [Bar(), Dashboard(), Calendar()],
});
