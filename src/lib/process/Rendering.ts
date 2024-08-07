import { Camera } from "@lib/data/scene-objects/Camera";
import { Scene } from "@lib/data/Scene";
import { mat4 } from "gl-matrix";
import { Program } from "@lib/gfx/Program";
import { Spatial } from "@lib/data/scene-objects/Spatial";
import { SceneCamera } from "@lib/data/scene-objects/SceneCamera";

export interface RenderingContext {
  projectionMatrix: mat4;
  viewMatrix: mat4;
}

export namespace RenderingContext {
  export const setProjection = (
    context: RenderingContext,
    camera: Camera,
    width: number,
    height: number
  ) => {
    Camera.toMatrix(context.projectionMatrix, camera, width, height);
  };

  export const setView = (context: RenderingContext, viewMatrix: mat4) => {
    mat4.copy(context.viewMatrix, viewMatrix);
  };
}

export namespace Rendering {
  const updateTransforms = (scene: Scene) => {
    // TODO can also update item visibility based on parent
    // dont need to do this probably
    /*
    const currentModelMatrix = scene.root.transform.localMatrix;
    let currentObject = scene.root as SceneObject;
    mat4.multiply(
      currentObject.transform.worldMatrix,
      currentModelMatrix,
      currentObject.transform.localMatrix
    );
    */
  };

  const useProgram = (
    gl: WebGL2RenderingContext,
    program: Program,
    renderingContext: RenderingContext
  ) => {
    gl.useProgram(program.program);
    gl.uniformMatrix4fv(
      program.locations.projection,
      false,
      renderingContext.projectionMatrix
    );
    gl.uniformMatrix4fv(
      program.locations.view,
      false,
      renderingContext.viewMatrix
    );
  };

  export const render = (
    canvas: HTMLCanvasElement,
    scene: Scene,
    camera: SceneCamera
  ) => {
    const context: RenderingContext = {
      projectionMatrix: mat4.create(),
      viewMatrix: mat4.create(),
    };

    RenderingContext.setProjection(
      context,
      camera.data,
      canvas.width,
      canvas.height
    );

    RenderingContext.setView(context, camera.spatial.runtime.worldMatrix);

    Spatial.updateRuntimeRecursive(scene.root.spatial);

    const gl = canvas.getContext("webgl2");
    if (!gl) {
      // TODO error
      throw "error";
    }

    updateTransforms(scene);

    // TODO for a given material we have to update the camera related uniforms

    for (const currentObject of scene.sceneObjects) {
      switch (currentObject.type) {
        case "root":
          break;
        case "empty":
          break;
        case "geometry":
          // SceneMesh.render(gl, currentObject);
          break;
        case "camera":
          break;
      }
    }
  };
}
