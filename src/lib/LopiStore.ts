import { createUniqueId } from "@utils/createUniqueId";
import { createStore, produce } from "solid-js/store";
import { Workspace } from "./views/Workspace";
import { Settings } from "./Settings";
import { Scene } from "./data/Scene";
import { Editor, Editor3d, EditorAnimation, EditorUV } from "./editors/Editor";

export interface LopiStoreAPI {
  workspaces: Workspace[];
  editors: Editor[];
  editorDefaults: {
    "3d": Editor3d | null;
    uv: EditorUV | null;
    animation: EditorAnimation | null;
  };
  scenes: Scene[];
  settings: Settings;
}

export const createLopiStore = () => {
  const [store, setStore] = createStore<LopiStoreAPI>({
    workspaces: [],
    editors: [],
    editorDefaults: {
      "3d": null,
      uv: null,
      animation: null,
    },
    scenes: [],
    settings: Settings.createDefault(),
  });
  return {
    addWorkspace: () => {
      const newWorkspace: Workspace = {
        id: createUniqueId("workspace"),
        name: "",
        editorIds: [],
        isSplit: false,
      };
      setStore("workspaces", store.workspaces.length, newWorkspace);
      return newWorkspace.id;
    },
    removeWorkspace: (id: string) => {
      setStore(
        "workspaces",
        store.workspaces.filter((workspace) => workspace.id !== id)
      );
    },
    getWorkspaces: () => {
      return store.workspaces;
    },
    getWorkspace: (id: string) => {
      return store.workspaces.find((workspace) => workspace.id === id);
    },
    setWorkspace: (id: string, updateObject: Partial<Workspace>) => {
      setStore("workspaces", (workspace) => workspace.id === id, updateObject);
    },
    addEditor: (editor: Editor) => {
      setStore("editors", store.editors.length, editor);
      return editor.id;
    },
    getEditor: (id: string) => {
      return store.editors.find((editor) => editor.id === id);
    },
    produceEditor: (id: string, mutateFn: (editor: Editor) => void) => {
      setStore("editors", (editor) => editor.id === id, produce(mutateFn));
    },
    addScene: (scene: Scene) => {
      setStore("scenes", store.scenes.length, scene);
      return scene.id;
    },
    getScenes: () => {
      return store.scenes;
    },
    getScene: (id: string) => {
      return store.scenes.find((scene) => scene.id === id);
    },
    produceScene: (id: string, mutateFn: (scene: Scene) => void) => {
      setStore("scenes", (scene) => scene.id === id, produce(mutateFn));
    },
    getSettings: () => {
      return store.settings;
    },
    setSettings: (updateObject: Partial<Settings>) => {
      return setStore("settings", updateObject);
    },
  };
};

export type LopiStore = ReturnType<typeof createLopiStore>;
