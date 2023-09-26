import React, { useState } from "react";
import { motion } from "framer-motion";
import { debugData } from "./utils/debugData";
import { fetchNui } from "./utils/fetchNui";
import {
    VisibilityProvider,
    useVisibility,
} from "./providers/VisibilityProvider";
import { FaUsers } from "react-icons/fa";
// This will set the NUI to visible if we are
// developing in browser
debugData([
    {
        action: "setVisible",
        data: true,
    },
]);

const App: React.FC = () => {
    const { visible } = useVisibility();
    const [page, setPage] = useState("init");
    const handleGetReward = () => {
        console.log("get reward");
        setPage("got");
    };
    const handleCreatorCode = () => {
        setPage("creator");
    };
    const handleCreatorCodeCheck = () => {
        setPage("init");
    };
    window.addEventListener("keypress", (e) => {
        console.log(e);
    });
    return (
        <>
            {visible && (
                <motion.div
                    initial={{ scale: 0.9, opacity: 0 }}
                    animate={{
                        opacity: 1,
                        scale: 1,
                        transition: { duration: 0.3 },
                    }}
                    className="relative w-[1000px] h-[550px] rounded-[30px] overflow-hidden flex items-center justify-center"
                >
                    <img
                        className="absolute w-[100%] h-[100%] z-[-1]"
                        src="/web/build/img/bg.jpg"
                    />
                    {page === "init" && (
                        <div className=" flex flex-col items-center">
                            <img
                                src="/web/build/img/logo.png"
                                className="w-[200px] h-[110px] object-cover"
                            />
                            <h1 className="relative text-white font-mortend text-[50px] text-center white-shadow">
                                CANX{" "}
                                <span className="text-blue-600 text-[40px] blue-shadow absolute top-[-15px] right-[-20px] font-sans font-black  rotate-[30deg]">
                                    RP
                                </span>
                            </h1>
                            <h3 className="uppercase text-blue-600 font-akrobat text-[25px] blue-shadow relative top-[-25px]">
                                Welcome
                            </h3>
                            <div className="flex gap-[10px] font-akrobat items-center">
                                <div className="h-[40px] w-[40px] bg-[#0581db77] border-blue-500 border text-white rounded-[5px] flex items-center justify-center text-[20px]">
                                    <FaUsers />
                                </div>
                                <h1 className="text-white text-[20px]">
                                    OVER {1000} CITIZEN
                                </h1>
                            </div>
                            <div className="flex flex-col h-[120px]">
                                <button
                                    onClick={handleGetReward}
                                    className="text-[30px] font-akrobat text-white bg-bluegradient rounded-[23px] w-[300px] mt-[30px] h-[50px] transition-all duration-300 hover:scale-105"
                                >
                                    CLAIM REWARD
                                </button>
                                <button
                                    onClick={handleCreatorCode}
                                    className="text-[25px] font-akrobat text-white rounded-[23px] w-[300px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                                >
                                    CREATOR CODE
                                </button>
                            </div>
                        </div>
                    )}
                    {page === "got" && (
                        <div className="flex flex-col items-center gap-[20px]">
                            <img
                                src="/web/build/img/gift.png"
                                className="h-[200px] "
                            />
                            <h3 className="uppercase text-white font-akrobat text-[25px] ">
                                Congrats! You Have Received a Welcome Gift.
                            </h3>
                            <button
                                onClick={() => {
                                    setPage("init");
                                }}
                                className="text-[30px] font-akrobat text-white bg-bluegradient rounded-[23px] w-[300px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                            >
                                GO BACK
                            </button>
                        </div>
                    )}
                    {page === "creator" && (
                        <div className="flex flex-col gap-[10px] items-center">
                            <img
                                src="/web/build/img/creator.png"
                                className="h-[200px] scale-110"
                            />
                            <input
                                type="text"
                                className="text-center bg-whitegradient text-white w-[300px] rounded-[23px] h-[50px] outline-none px-[10px] font-akrobat text-[20px]"
                                placeholder="CREATOR CODE"
                            />
                            <button
                                onClick={handleCreatorCodeCheck}
                                className="text-[30px] font-akrobat text-white bg-bluegradient rounded-[23px] w-[250px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                            >
                                CHECK CODE
                            </button>
                            <button
                                onClick={() => {
                                    setPage("init");
                                }}
                                className="text-[25px] font-akrobat text-white rounded-[23px] w-[300px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                            >
                                GO BACK
                            </button>
                        </div>
                    )}
                </motion.div>
            )}
        </>
    );
};

export default App;
