/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
    theme: {
        extend: {
            fontFamily: {
                mortend: ["mortend", "sans-serif"],
                akrobat: ["akrobat", "sans-serif"],
            },
        },
    },
    plugins: [],
};
