import React, { useEffect, useState } from "react";
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
    const { visible, setVisible } = useVisibility();
    const [page, setPage] = useState("init");
    const [citizen, setCitizen] = useState(0);
    const [giftState, setGiftState] = useState(
        "Congrats! You Have Received a Welcome Gift."
    );
    const [creatorCode, setCreatorCode] = useState("");
    const handleCreatorCodeCheck = async () => {
        const data = await fetchNui("gerRewardFromCode", { code: creatorCode });
        if (data.state === "got") {
            setPage("init");
        } else if (data.state === "already") {
            setPage("got");
            setGiftState("You've already received your gift!");
        }
    };
    const [locale, setLocale] = useState({
        logo: "/web/build/img/logo.png",
        svname: "CANX",
        welcome: "Welcome",
        citizen: "CITIZENS",
        over: "OVER",
        claim_reward: "CLAIM REWARD",
        creator_code: "CREATOR CODE",
        go_back: "GO BACK",
        check_code: "CHECK CODE",
    });
    useEffect(() => {
        const getCitizenData = async () => {
            const data = await fetchNui("getCitizenCount");
            setCitizen(data);
        };

        const getLocaleData = async () => {
            const data = await fetchNui("setLocale");

            setLocale(data.Locale);
        };
        getLocaleData();
        getCitizenData();
    }, []);
    const handleGetReward = async () => {
        const data = await fetchNui("gerReward");
        if (data.state === "got") {
            setPage("got");
        } else if (data.state === "already") {
            setGiftState("You've already received your gift!");
            setPage("got");
        }
    };
    const handleCreatorCode = () => {
        setPage("creator");
    };

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
                                src={locale.logo}
                                className="w-[200px] h-[110px] object-contain"
                            />
                            <h1 className="relative text-white font-mortend text-[50px] text-center white-shadow">
                                {locale.svname}{" "}
                                <span className="text-blue-600 text-[40px] blue-shadow absolute top-[-15px] right-[-20px] font-sans font-black  rotate-[30deg]">
                                    RP
                                </span>
                            </h1>
                            <h3 className="uppercase text-blue-600 font-akrobat text-[25px] blue-shadow relative top-[-25px]">
                                {locale.welcome}
                            </h3>
                            <div className="flex gap-[10px] font-akrobat items-center">
                                <div className="h-[40px] w-[40px] bg-[#0581db77] border-blue-500 border text-white rounded-[5px] flex items-center justify-center text-[20px]">
                                    <FaUsers />
                                </div>
                                <h1 className="text-white text-[20px]">
                                    {locale.over}{" "}
                                    {Math.floor(citizen).toLocaleString()}{" "}
                                    {locale.citizen}
                                </h1>
                            </div>
                            <div className="flex flex-col h-[120px]">
                                <button
                                    onClick={handleGetReward}
                                    className="text-[30px] font-akrobat text-white bg-bluegradient rounded-[23px] w-[300px] mt-[30px] h-[50px] transition-all duration-300 hover:scale-105"
                                >
                                    {locale.claim_reward}
                                </button>
                                <button
                                    onClick={handleCreatorCode}
                                    className="text-[25px] font-akrobat text-white rounded-[23px] w-[300px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                                >
                                    {locale.creator_code}
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
                                {giftState}
                            </h3>
                            <button
                                onClick={() => {
                                    setPage("init");
                                }}
                                className="text-[30px] font-akrobat text-white bg-bluegradient rounded-[23px] w-[300px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                            >
                                {locale.go_back}
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
                                value={creatorCode}
                                onChange={(e) => {
                                    setCreatorCode(e.target.value);
                                }}
                            />
                            <button
                                onClick={handleCreatorCodeCheck}
                                className="text-[30px] font-akrobat text-white bg-bluegradient rounded-[23px] w-[250px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                            >
                                {locale.check_code}
                            </button>
                            <button
                                onClick={() => {
                                    setPage("init");
                                }}
                                className="text-[25px] font-akrobat text-white rounded-[23px] w-[300px] mt-[10px] h-[50px] transition-all duration-300 hover:scale-105"
                            >
                                {locale.go_back}
                            </button>
                        </div>
                    )}
                </motion.div>
            )}
        </>
    );
};

export default App;
